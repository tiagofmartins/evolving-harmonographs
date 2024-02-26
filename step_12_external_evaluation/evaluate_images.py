import os, time
from PIL import Image

this_script_dir = os.path.abspath(os.path.dirname(__file__))
path_file_images_list = os.path.join(this_script_dir, 'images_list.txt')
path_file_images_fitness = os.path.join(this_script_dir, 'images_fitness.txt')

def evaluate_image(img_path):
    img = Image.open(img_path)
    # ---------- replace the code below with your fitness function
    img = img.convert('L')
    count = 0
    for x in range(img.width):
        for y in range(img.height):
            if img.getpixel((x, y)) < 128:
                count += 1
    fitness = count / (img.width * img.height)
    # ---------- replace the code above with your fitness function
    return fitness

if __name__ == '__main__':
    try:
        print('Waiting for images')
        while True:
            if os.path.exists(path_file_images_list) and os.path.isfile(path_file_images_list):
                print('Evaluating images')
                with open(path_file_images_list) as f:
                    images_paths = [line.strip() for line in f]
                images_fitness = [evaluate_image(img_path) for img_path in images_paths]
                assert not os.path.exists(path_file_images_fitness)
                with open(path_file_images_fitness, 'w') as f:
                    f.write('\n'.join([str(v) for v in images_fitness]))
                os.remove(path_file_images_list)
                print('Waiting for images')
            time.sleep(0.5)
    except KeyboardInterrupt:
        pass