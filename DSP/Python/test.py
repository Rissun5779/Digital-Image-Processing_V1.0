import numpy as np
import cv2
import matplotlib.pyplot as plt
import os


class ImageProcessor:
    def __init__(self, image_path):
        # 讀取影像並轉為灰階
        self.img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
        if self.img is None:
            raise ValueError(f"無法讀取影像，請檢查路徑: {image_path}")

    def quantize(self, levels):
        """線性量化實作"""
        # levels 是目標位階數 (N)
        # 公式: delta = 255 / (N - 1)
        delta = 255 / (levels - 1)
        # 公式: I_new = round(I_old / delta) * delta
        quantized = np.round(self.img / delta) * delta
        return quantized.astype(np.uint8)

    def get_bit_plane(self, plane):
        """位元平面切片 (1-8)"""
        mask = 1 << (plane - 1)
        res = self.img & mask
        res[res > 0] = 255
        return res.astype(np.uint8)

    def ordered_dither(self, n=4):
        """有序抖動 (Bayer Matrix)"""

        def bayer_matrix(n):
            if n == 1:
                return np.array([[0]])
            bn = bayer_matrix(n // 2)
            return np.vstack(
                [np.hstack([4 * bn, 4 * bn + 2]), np.hstack([4 * bn + 3, 4 * bn + 1])]
            )

        matrix = bayer_matrix(n)
        m_size = matrix.shape[0]
        threshold = (matrix + 0.5) * (255 / (m_size**2))

        h, w = self.img.shape
        t_map = np.tile(threshold, (h // m_size + 1, w // m_size + 1))[:h, :w]
        return (self.img > t_map).astype(np.uint8) * 255

    def error_diffusion(self):
        """Floyd-Steinberg 誤差擴散"""
        h, w = self.img.shape
        out = self.img.astype(float).copy()
        for y in range(h - 1):
            for x in range(1, w - 1):
                old_pixel = out[y, x]
                new_pixel = 255 if old_pixel > 127 else 0
                out[y, x] = new_pixel
                err = old_pixel - new_pixel

                # 權重分配: 右(7/16), 左下(3/16), 下(5/16), 右下(1/16)
                out[y, x + 1] += err * 7 / 16
                out[y + 1, x - 1] += err * 3 / 16
                out[y + 1, x] += err * 5 / 16
                out[y + 1, x + 1] += err * 1 / 16
        return np.clip(out, 0, 255).astype(np.uint8)


# --- 執行部分 ---
# 根據你的 dir 輸出，影像檔案就在同一個目錄
img_name = "lenna.png"

if __name__ == "__main__":
    try:
        processor = ImageProcessor(img_name)

        plt.figure(figsize=(15, 10))
        (
            plt.subplot(231),
            plt.imshow(processor.img, cmap="gray"),
            plt.title("Original (8-bit)"),
        )
        # 量化為 4 個位階 [cite: 330]
        (
            plt.subplot(232),
            plt.imshow(processor.quantize(4), cmap="gray"),
            plt.title("Quantized (4 levels)"),
        )
        # 顯示最高位位元平面 [cite: 269]
        (
            plt.subplot(233),
            plt.imshow(processor.get_bit_plane(8), cmap="gray"),
            plt.title("8th Bit-plane (MSB)"),
        )
        # 顯示最低位位元平面 [cite: 271]
        (
            plt.subplot(234),
            plt.imshow(processor.get_bit_plane(1), cmap="gray"),
            plt.title("1st Bit-plane (LSB)"),
        )
        # 執行 4x4 有序抖動 [cite: 428]
        (
            plt.subplot(235),
            plt.imshow(processor.ordered_dither(4), cmap="gray"),
            plt.title("Ordered Dither (4x4)"),
        )
        # 執行誤差擴散 [cite: 445]
        (
            plt.subplot(236),
            plt.imshow(processor.error_diffusion(), cmap="gray"),
            plt.title("Error Diffusion"),
        )

        plt.tight_layout()
        plt.show()
    except Exception as e:
        print(f"發生錯誤: {e}")
