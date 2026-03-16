import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import csv


class SignalApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("DSP Signal Generator & Q15 Expert (Full Suite)")
        self.geometry("1150x700")

        self.freq = tk.DoubleVar(value=5.0)
        self.amp = tk.DoubleVar(value=1.0)
        self.signals = []

        # ======= 主框架 =======
        main_frame = tk.Frame(self)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # 左側輸入區
        left_frame = tk.Frame(main_frame)
        left_frame.pack(side=tk.LEFT, fill=tk.Y, anchor="n")

        # 訊號參數輸入
        input_group = tk.LabelFrame(
            left_frame, text="Signal Parameters", padx=10, pady=10
        )
        input_group.pack(fill=tk.X, pady=5)

        tk.Label(input_group, text="Frequency (Hz)").pack(anchor="w")
        self.freq_entry = tk.Entry(input_group, textvariable=self.freq, width=12)
        self.freq_entry.pack(pady=5)

        tk.Label(input_group, text="Amplitude").pack(anchor="w")
        self.amp_entry = tk.Entry(input_group, textvariable=self.amp, width=12)
        self.amp_entry.pack(pady=5)

        tk.Button(
            input_group, text="Add Signal", command=self.add_signal, bg="lightyellow"
        ).pack(fill=tk.X, pady=5)

        # 🟢 Nyquist 估計顯示
        self.nyquist_var = tk.StringVar(value="Nyquist Min: 0 pts")
        nyquist_label = tk.Label(
            left_frame,
            textvariable=self.nyquist_var,
            fg="darkred",
            font=("Arial", 9, "bold"),
            justify="left",
        )
        nyquist_label.pack(pady=15, anchor="w")

        # ======= 右側區域 =======
        right_container = tk.Frame(main_frame)
        right_container.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=10)

        list_frame = tk.LabelFrame(right_container, text="Overlay List", padx=5, pady=5)
        list_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.signal_listbox = tk.Listbox(list_frame)
        self.signal_listbox.pack(fill=tk.BOTH, expand=True)
        tk.Button(list_frame, text="Delete Selected", command=self.delete_signal).pack(
            pady=5
        )

        # 數位化與導出
        digital_frame = tk.LabelFrame(
            right_container, text="Sampling & Metrics", padx=10, pady=10
        )
        digital_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=5)

        tk.Label(
            digital_frame,
            text="Sampling Points\n(Nios V Buffer)",
            font=("Arial", 9, "bold"),
        ).pack(pady=5)
        self.points_var = tk.StringVar(value="256")
        self.points_cb = ttk.Combobox(
            digital_frame,
            textvariable=self.points_var,
            values=[str(2**i) for i in range(3, 13)],
            width=10,
            state="readonly",
        )
        self.points_cb.pack(pady=5)
        self.points_cb.bind("<<ComboboxSelected>>", lambda e: self.update_plot())

        tk.Label(digital_frame, text="Digital Levels", font=("Arial", 9, "bold")).pack(
            pady=10
        )
        self.levels_var = tk.StringVar(value="256")
        self.level_cb = ttk.Combobox(
            digital_frame,
            textvariable=self.levels_var,
            values=[str(2**i) for i in range(3, 13)],
            width=10,
            state="readonly",
        )
        self.level_cb.pack(pady=5)

        tk.Button(
            digital_frame,
            text="Analysis Window",
            command=self.show_digital_window,
            bg="lightblue",
        ).pack(fill=tk.X, pady=5)
        tk.Button(
            digital_frame, text="Export CSV", command=self.export_csv, bg="lightgreen"
        ).pack(fill=tk.X, pady=5)
        tk.Button(
            digital_frame,
            text="Export Q15 CSV",
            command=self.export_q15_csv,
            bg="orange",
        ).pack(fill=tk.X, pady=5)

        # ======= 繪圖區 =======
        plot_frame = tk.Frame(self, bg="white", bd=1, relief=tk.RIDGE)
        plot_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        self.fig, self.ax = plt.subplots(figsize=(9, 4))
        self.canvas = FigureCanvasTkAgg(self.fig, master=plot_frame)
        self.canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)

        self.update_plot()

    def generate_discrete_data(self, num_points, duration=1.0):
        t = np.linspace(0, duration, num_points, endpoint=False)
        y_total = np.zeros(num_points)
        for amp, freq in self.signals:
            y_total += amp * np.sin(2 * np.pi * freq * t)
        return t, y_total

    def update_nyquist_info(self):
        if not self.signals:
            self.nyquist_var.set("Nyquist Min: 0 pts")
            return
        max_f = max([sig[1] for sig in self.signals])
        self.nyquist_var.set(
            f"Highest Freq: {max_f} Hz\nNyquist Min: {2 * max_f} pts\nRecommended: >{int(max_f * 10)} pts"
        )

    def add_signal(self):
        try:
            self.signals.append((float(self.amp.get()), float(self.freq.get())))
            self.signal_listbox.insert(
                tk.END, f"A={self.amp.get()}, f={self.freq.get()} Hz"
            )
            self.update_plot()
        except ValueError:
            messagebox.showwarning("Input Error", "Please enter valid numbers.")

    def delete_signal(self):
        selected = self.signal_listbox.curselection()
        if selected:
            self.signals.pop(selected[0])
            self.signal_listbox.delete(selected[0])
            self.update_plot()

    def update_plot(self):
        self.update_nyquist_info()
        self.ax.clear()

        if self.signals:
            max_f = max([sig[1] for sig in self.signals])
            view_duration = 1.5 / max_f
        else:
            view_duration = 1.0

        # 1. 模擬「類比連續」
        t_cont = np.linspace(0, view_duration, 1000, endpoint=False)
        y_cont = np.zeros(1000)
        for amp, freq in self.signals:
            y_cont += amp * np.sin(2 * np.pi * freq * t_cont)

        # 2. 「離散取樣」
        num_p = int(self.points_var.get())
        t_discrete, y_discrete = self.generate_discrete_data(
            num_p, duration=view_duration
        )

        self.ax.plot(t_cont * 1000, y_cont, color="gray", alpha=0.3, label="Analog")

        if num_p <= 64:
            self.ax.stem(
                t_discrete * 1000,
                y_discrete,
                linefmt="C1-",
                markerfmt="C1o",
                label=f"Digital ({num_p} pts)",
            )
        else:
            self.ax.plot(
                t_discrete * 1000,
                y_discrete,
                "C1o-",
                markersize=3,
                alpha=0.7,
                label=f"Digital ({num_p} pts)",
            )

        self.ax.set_xlabel("Time [ms]")
        self.ax.set_title(f"Dynamic Observation: {view_duration * 1000:.1f}ms")
        self.ax.set_xlim(0, view_duration * 1000)
        self.ax.legend(loc="upper right")
        self.ax.grid(True, linestyle=":", alpha=0.6)
        self.canvas.draw()

    # 🟢 核心數學：量化誤差量化
    def calculate_metrics(self, y_analog, y_quantized):
        error = y_analog - y_quantized
        rmse = np.sqrt(np.mean(error**2))
        sig_rms = np.sqrt(np.mean(y_analog**2))
        sqnr = 20 * np.log10(sig_rms / rmse) if rmse > 0 else float("inf")
        return error, rmse, sqnr

    def get_quantized_signal(self, y_total, levels):
        y_min, y_max = np.min(y_total), np.max(y_total)
        if y_max == y_min:
            return y_total
        y_norm = (y_total - y_min) / (y_max - y_min)
        y_quant = np.round(y_norm * (levels - 1)) / (levels - 1)
        return y_quant * (y_max - y_min) + y_min

    def show_digital_window(self):
        if not self.signals:
            return
        levels = int(self.levels_var.get())
        num_p = int(self.points_var.get())

        # 獲取一秒內的完整數據進行分析
        t, y_analog = self.generate_discrete_data(num_p, duration=1.0)
        y_quant = self.get_quantized_signal(y_analog, levels)
        error, rmse, sqnr = self.calculate_metrics(y_analog, y_quant)

        new_win = tk.Toplevel(self)
        new_win.title(f"Quantization Analysis ({levels} levels, {num_p} samples)")

        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 7), sharex=True)
        plt.subplots_adjust(hspace=0.35)

        ax1.step(t * 1000, y_quant, where="mid", color="red", label="Quantized")
        ax1.plot(t * 1000, y_analog, "k--", alpha=0.2, label="Ideal")
        ax1.set_title(f"Signal Comparison (RMSE: {rmse:.4f})")
        ax1.legend()

        ax2.fill_between(
            t * 1000, error, color="purple", alpha=0.4, label="Noise (Error)"
        )
        ax2.axhline(0, color="black", lw=1)
        ax2.set_title(f"Quantization Noise Floor (SQNR: {sqnr:.2f} dB)")
        ax2.set_xlabel("Time [ms]")
        ax2.legend()

        canvas = FigureCanvasTkAgg(fig, master=new_win)
        canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)

    def export_csv(self):
        if not self.signals:
            return
        num_p = int(self.points_var.get())
        t, y = self.generate_discrete_data(num_p, duration=1.0)
        path = filedialog.asksaveasfilename(defaultextension=".csv")
        if path:
            with open(path, "w", newline="") as f:
                writer = csv.writer(f)
                writer.writerow(["Index", "Time_ms", "Amplitude"])
                for i in range(len(t)):
                    writer.writerow([i, t[i] * 1000, y[i]])
            messagebox.showinfo("Exported", f"Saved {num_p} points.")

    def export_q15_csv(self):
        if not self.signals:
            return
        num_p = int(self.points_var.get())
        t, y_total = self.generate_discrete_data(num_p, duration=1.0)
        max_v = np.max(np.abs(y_total))
        y_norm = y_total / max_v if max_v > 0 else y_total
        q15 = np.clip(np.round(y_norm * 32768), -32768, 32767).astype(np.int16)
        path = filedialog.asksaveasfilename(defaultextension=".csv")
        if path:
            with open(path, "w", newline="") as f:
                writer = csv.writer(f)
                writer.writerow(["Index", "Q15_Int", "Hex"])
                for i in range(len(t)):
                    writer.writerow([i, q15[i], f"0x{q15[i] & 0xFFFF:04x}"])
            messagebox.showinfo(
                "Exported", f"Q15 Hex data saved.\nPeak Scale: {max_v:.2f}"
            )


if __name__ == "__main__":
    app = SignalApp()
    app.mainloop()
