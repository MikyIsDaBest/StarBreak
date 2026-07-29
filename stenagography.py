#!/usr/bin/env python3
import argparse
import os
from PIL import Image
import stepic

def hide_data(image_path, data, output_path):
    """Hide data in image using steganography"""
    img = Image.open(image_path)
    encoded = stepic.encode(img, data.encode())
    encoded.save(output_path)
    print(f"[+] Data hidden in {output_path}")

def extract_data(image_path):
    """Extract hidden data from image"""
    img = Image.open(image_path)
    data = stepic.decode(img)
    print(f"[+] Extracted: {data}")
    return data

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hide", action="store_true", help="Hide data in image")
    parser.add_argument("--extract", action="store_true", help="Extract data from image")
    parser.add_argument("--image", required=True, help="Image file path")
    parser.add_argument("--data", help="Data to hide")
    parser.add_argument("--output", default="output.png", help="Output image path")
    args = parser.parse_args()
    
    if args.hide and args.data:
        hide_data(args.image, args.data, args.output)
    elif args.extract:
        extract_data(args.image)
    else:
        print("Use --hide or --extract")

if __name__ == "__main__":
    main()
