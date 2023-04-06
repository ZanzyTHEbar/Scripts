from imutils import paths
from PIL import Image
import argparse
import requests
import cv2
import os
import numpy as np

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument(
    "-u", "--urls", required=True, help="path to file containing image URLs"
)
ap.add_argument(
    "-o", "--output", required=True, help="path to output directory of images"
)
ap.add_argument(
    "-s", "--start", required=False, help="First number to start at", default=0
)
ap.add_argument(
    "-v",
    "--verbose",
    required=False,
    help="Print information as we go",
    action="store_true",
    default=False,
)
ap.add_argument("-d", "--dataset", required=True, help="path to input dataset")
ap.add_argument(
    "-r",
    "--remove",
    required=False,
    default=False,
    action="store_true",
    help="whether or not duplicates and watermarks should be removed (i.e., dry run)",
)


# grab the list of URLs from the input file, then initialize the total
def read_url_list(filename):
    return open(filename).read().strip().split("\n")


# generator to read URLs and return data
def read_urls(urls, is_verbose=False):
    for url in urls:
        try:
            # try to download the image
            if is_verbose:
                print("Downloading {}".format(url))
            r = requests.get(url, timeout=60)
            yield ((url, r.content))
        except requests.exceptions.RequestException as e:
            print("Error downloading {} : {}".format(url, e))


# test if files are image data that OpenCV can read
def return_images(file_contents, is_verbose=False):
    for url, data in file_contents:
        try:
            # convert to numpy array that OpenCV can read
            nparr = np.frombuffer(data, np.uint8)
            # attempt to decode data as image
            img_cv = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
            if img_cv is None:
                if is_verbose:
                    print("Skipping {} - not an image".format(url))
            else:
                # return the image
                yield ((url, img_cv))
        except Exception as err:
            if is_verbose:
                print("Error parsing {} : {}".format(url, err))


def write_images(images, output_dir, start=0, is_verbose=False):
    file_num = start
    for url, image in images:
        p = os.path.sep.join([output_dir, "{}.png".format(str(file_num).zfill(8))])
        cv2.imwrite(p, image)
        file_num += 1
        if is_verbose:
            print("{} <- {}".format(p, url))


def removeWatermark(remove, output_dir, start=0, is_verbose=False):

    if remove:
        delete = False
        file_num = start
        # grab the paths to all input images in the input directory
        print("[INFO] removing watermarks...")
        imagePaths = list(paths.list_images(args["dataset"]))
        # initialize our images dictionary
        # loop over the image paths
        for imagePath in imagePaths:
            try:
                # try to load the image
                # if OpenCV cannot load the image then the image is likely
                # corrupt so we should delete it
                image = cv2.imread(imagePath)
                # if the image is `None` then we could not properly load it
                # from disk, so delete it
                # compute the difference hash for the image and update the
                # images dictionary
                if image is None:
                    delete = True
                else:
                    # Convert the image to grayscale
                    gr = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

                    # Make a copy of the grayscale image
                    bg = gr.copy()

                    # Apply morphological transformations
                    for i in range(5):
                        kernel2 = cv2.getStructuringElement(
                            cv2.MORPH_ELLIPSE, (2 * i + 1, 2 * i + 1)
                        )
                        bg = cv2.morphologyEx(bg, cv2.MORPH_CLOSE, kernel2)
                        bg = cv2.morphologyEx(bg, cv2.MORPH_OPEN, kernel2)

                    # Subtract the grayscale image from its processed copy
                    dif = cv2.subtract(bg, gr)

                    # Apply thresholding
                    bw = cv2.threshold(
                        dif, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU
                    )[1]
                    dark = cv2.threshold(
                        bg, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU
                    )[1]

                    # Extract pixels in the dark region
                    darkpix = gr[np.where(dark > 0)]

                    # Threshold the dark region to get the darker pixels inside it
                    darkpix = cv2.threshold(
                        darkpix, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU
                    )[1]

                    # Paste the extracted darker pixels in the watermark region
                    bw[np.where(dark > 0)] = darkpix.T
                    bw = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
                    p = os.path.sep.join(
                        [output_dir, "{}.png".format(str(file_num).zfill(8))]
                    )
                    cv2.imwrite(p, bw)
                    file_num += 1
                    if is_verbose:
                        print("{}".format(p))
            except:
                print("Removing watermark failed")
                delete = True
        # check to see if the image should be deleted
        if delete:
            print("[INFO] deleting {}".format(imagePath))
            os.remove(imagePath)
        return
    print("[INFO] not removing watermarks...")


def removeDuplicates(remove):

    if remove:
        delete = False
        # grab the paths to all input images in the input directory
        print("[INFO] finding duplicate images...")
        imagePaths = list(paths.list_images(args["dataset"]))
        # initialize our images dictionary
        # loop over the image paths
        for imagePath in imagePaths:
            try:
                # try to load the image
                # if OpenCV cannot load the image then the image is likely
                # corrupt so we should delete it
                image = cv2.imread(imagePath)
                # if the image is `None` then we could not properly load it
                # from disk, so delete it
                # compute the difference hash for the image and update the
                # images dictionary
                if image is None:
                    delete = True
                else:
                    h = dhash(image)
                    p = h.get(h, [])
                    p.append(imagePath)
                    h[h] = p
                    # initialize our duplicate image paths list
                    duplicates = []
                    # loop over the hashes dictionary
                    for (k, v) in list(h[h].items()):
                        # grab the paths to all duplicate images
                        if len(h[h]) > 1:
                            if h[h] == h[h]:
                                duplicates.append((v, h[h][k]))
                                print("[INFO] deleting {}".format(duplicates))
                                os.remove(duplicates)
                                # return the duplicate image paths
                                return duplicates
            except:
                print("Removing duplicates failed, no duplicates found")
                delete = True
        # check to see if the image should be deleted
        if delete:
            print("[INFO] deleting {}".format(imagePath))
            os.remove(imagePath)
        return
    print("[INFO] not removing duplicates...")


def dhash(image, hashSize=8):
    # convert the image to grayscale and resize the grayscale image,
    # adding a single column (width) so we can compute the horizontal
    # gradient
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    resized = cv2.resize(gray, (hashSize + 1, hashSize))
    # compute the (relative) horizontal gradient between adjacent
    # column pixels
    diff = resized[:, 1:] > resized[:, :-1]
    # convert the difference image to a hash and return it
    return sum([2**i for (i, v) in enumerate(diff.flatten()) if v])


if __name__ == "__main__":
    args = vars(ap.parse_args())
    path = r"images"  # path to all .jpg images
    output_dir = args["output"]
    is_verbose = args["verbose"]
    start = int(args["start"])
    remove = args["remove"]

    urls = read_url_list(args["urls"])
    url_data = read_urls(urls, is_verbose)
    images = return_images(url_data, is_verbose)
    write_images(images, output_dir, start, is_verbose)
    removeDuplicates(remove)
    #removeWatermark(remove, output_dir, start, is_verbose)
    print("[INFO] done")
