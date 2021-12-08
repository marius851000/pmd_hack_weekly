from PIL import Image

input_name = 'Hurt-'
output_name = 'Cringe-'
subnames = ['Anim', 'Shadow', 'Offsets']

for sub in subnames:
    hurt_image = Image.open(f'{input_name}{sub}.png')
    image_size = hurt_image.size
    frame_height = image_size[1] // 8
    cringe_image = hurt_image.crop((0, 0, image_size[0], frame_height))
    new_name = f'{output_name}{sub}.png'
    cringe_image.save(new_name)
