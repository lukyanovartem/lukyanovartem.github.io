---
title: Запуск Stable Diffusion на слабом железе 
published: 25.04.2025
tags: ai
---

Удалось запустить Stable Diffusion на слабой машине с интегрированной карточкой Intel UHD Graphics 620.  
Для запуска использовал софт <https://github.com/leejet/stable-diffusion.cpp> (нужно собирать с поддержкой Vulkan).  
И модель <https://huggingface.co/stabilityai/sdxl-turbo/blob/main/sd_xl_turbo_1.0_fp16.safetensors>  
Параметры для запуска описаны в [README](https://huggingface.co/stabilityai/sdxl-turbo) модели. Единственное отличие в том, что вместо `guidance_scale=0.0` нужно использовать `cfg-scale 1`.  
Другая моделька <https://huggingface.co/RunDiffusion/Juggernaut-X-Hyper/blob/main/JuggernautXRundiffusion_Hyper.safetensors>  
Для борбы с нехваткой памяти следует использовать TAESD <https://huggingface.co/madebyollin/taesdxl/blob/main/diffusion_pytorch_model.safetensors> и параметр `clip-on-cpu`.  
Поскольку изображение получается размера 512x512, можно использовать апскейлер <https://civitai.com/models/147821/realesrganx4plus-anime-6b> или <https://civitai.com/models/147817/realesrganx4plus> для увеличения разрешения в 4 раза.