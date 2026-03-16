import tkinter as tk
from tkinter import messagebox
from tkinter import *

# SignalApp 繼承 tk.Tk GUI框架
class SignalApp(tk.Tk):
    # SignalApp 初始化方法 設定視窗標題和大小
    def __init__(self):
        # 呼叫父類別的初始化方法 建立基本的 GUI框架
        super().__init__()
        self.title("Signal Generator with Overlay & Digitalization")
        self.geometry("1024x768")
        # Var
        self.freq = tk.DoubleVar(value=5.0)
        self.amp = tk.DoubleVar(value=1.0)
        self.signals = []
        # Main
        main_frame = tk.Frame(self)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        # Put left_frame
        left_frame = tk.Frame(main_frame)
        left_frame.pack(side=tk.LEFT, fill=tk.Y, anchor="n")

        freq_frame = tk.Frame(left_frame)
        freq_frame.pack(anchor="w", pady=5)
        tk.Label(freq_frame, text="Frequency (Hz)").pack(side=tk.LEFT)
        self.freq_entry = tk.Entry(freq_frame, textvariable=self.freq, width=8)
        self.freq_entry.pack(side=tk.LEFT, padx=5)

        amp_frame = tk.Frame(left_frame)
        amp_frame.pack(anchor="w", pady=5)
        tk.Label(amp_frame, text="Amplitude").pack(side=tk.LEFT)
        self.amp_entry = tk.Entry(amp_frame, textvariable=self.amp, width=8)
        self.amp_entry.pack(side=tk.LEFT, padx=5)

        add_button = tk.Button(left_frame, text="Add Signal", command=self.add_signal)
        add_button.pack(anchor="w", pady=10)
        # Put button in left_frame
        self.button1 = tk.Button(
            self.left_frame, text="Add Signal", command=self.add_signal
        )
        self.button1.pack(pady=10)

        clear_button = tk.Button(
            self.left_frame, text="Clear Signals", command=self.clear_signals
        )
        clear_button.pack(pady=5)

    def add_signal(self):
        try:
            amp  = float(self.amp.get())
            freq = float(self.freq.get())
            print(f"Signal added: Amplitude = {amp}, Frequency = {freq}")
        except ValueError as e:
            messagebox.showerror("Invalid Input", "Please enter valid numbers for amplitude and frequency.")
            return
        
        self.signals.append((amp, freq))
        self.signals_listbox.insert(tk.END, f"A={amp}, f={freq}Hz") 
        self.update_plot()

    def clear_signals(self):
        if not self.signals:
            messagebox.showinfo("No Signals", "There are no signals to clear.")
            return
        
        self.signals.clear()
        self.signals_listbox.delete(0, tk.END)
        self.update_plot()

if __name__ == "__main__":
    app = SignalApp()
    app.mainloop()