import os
import json
import requests

PINATA_API_KEY = '9043b88d87da690470a8'
PINATA_API_SECRET = 'ce56ac189e98ff1589065f2ca0808e4a0dae12137793909fdabfeab12bb826e0'

folder_path = './img'
metadata_folder = './metadata'
url = "https://api.pinata.cloud/pinning/pinFileToIPFS"
output_file = 'ipfs_links.txt'

# 本地代理
proxies = {
    "http": "http://127.0.0.1:7890",
    "https": "http://127.0.0.1:7890"
}

ipfs_links = []

# 确保 metadata 文件夹存在
if not os.path.exists(metadata_folder):
    os.makedirs(metadata_folder)

for filename in os.listdir(folder_path):
    file_path = os.path.join(folder_path, filename)
    if os.path.isfile(file_path) and filename.lower().endswith(('.png', '.jpg', '.jpeg', '.jfif', '.gif')):
        print(f"处理 {filename} ...")

        # 上传图片到 IPFS
        with open(file_path, 'rb') as file:
            files = {'file': (filename, file)}
            headers = {
                "pinata_api_key": PINATA_API_KEY,
                "pinata_secret_api_key": PINATA_API_SECRET
            }
            response = requests.post(url, files=files, headers=headers, proxies=proxies)

        if response.status_code == 200:
            image_data = response.json()
            image_cid = image_data['IpfsHash']
            image_url = f"https://gateway.pinata.cloud/ipfs/{image_cid}"
            print(f"图片上传成功！URL: {image_url}")

            # 生成元数据 JSON
            metadata = {
                "name": f"Image NFT - {filename}",
                "description": f"An NFT representing the image {filename}",
                "image": image_url
            }
            metadata_filename = os.path.splitext(filename)[0] + '.json'
            metadata_path = os.path.join(metadata_folder, metadata_filename)

            with open(metadata_path, 'w') as metadata_file:
                json.dump(metadata, metadata_file, indent=4)

            # 上传元数据 JSON 到 IPFS
            with open(metadata_path, 'rb') as metadata_file:
                files = {'file': (metadata_filename, metadata_file)}
                response = requests.post(url, files=files, headers=headers, proxies=proxies)

            if response.status_code == 200:
                metadata_data = response.json()
                metadata_cid = metadata_data['IpfsHash']
                metadata_url = f"https://gateway.pinata.cloud/ipfs/{metadata_cid}"
                print(f"元数据上传成功！URL: {metadata_url}")
                ipfs_links.append({"image": image_url, "metadata": metadata_url})
            else:
                print(f"元数据上传失败 {metadata_filename}: {response.status_code} {response.text}")
        else:
            print(f"图片上传失败 {filename}: {response.status_code} {response.text}")

with open(output_file, 'w') as f:
    for link in ipfs_links:
        f.write(f"Image: {link['image']}\nMetadata: {link['metadata']}\n\n")

print(f"所有上传完成，链接已保存到 {output_file}")