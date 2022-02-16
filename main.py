from __future__ import division
from PIL import Image

if __name__ == '__main__':
    image = Image.open('Trondheim_NDVI.png')
    pixels = image.load()
    print(image.size)

    width = image.size[0]
    height = image.size[1]
    print(width)
    print(height)

    red_threshold = 25
    green_threshold = 50
    blue_threshold = 25

    green_pixel_count = 0
    total_pixel_count = width*height

    greenest_pixel_value = 0

    for x in range(0, width):
        for y in range(0, height):

            current_pixel = pixels[x, y]
            print(current_pixel)

            if current_pixel[0] > red_threshold or current_pixel[2] > blue_threshold:
                continue

            if current_pixel[1] > green_threshold:
                green_pixel_count += 1

    print(green_pixel_count)
    print(total_pixel_count)

    green_amount = green_pixel_count / total_pixel_count
    print(green_amount)

