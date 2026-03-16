import flet


def main(page: flet.Page):
    page.title = "DSP Main GUI"
    page.window_width = 300
    page.window_height = 400

    display = flet.TextField(
        value="",
        text_align=flet.TextAlign.RIGHT,
        width=300,
        height=50,
        read_only=True,
    )

    def button_click(e):
        display.value = (display.value or "") + e.control.text
        page.update()

    def clear_click(e):
        display.value = ""
        page.update()

    def equal_click(e):
        try:
            display.value = str(eval(display.value))
        except:
            display.value = "Error"
        page.update()

    def create_button(text):
        return flet.ElevatedButton(
            text=text, width=70, height=50, on_click=button_click
        )

    page.add(
        flet.Column(
            [
                display,
                flet.Row(
                    [
                        create_button("7"),
                        create_button("8"),
                        create_button("9"),
                        create_button("/"),
                    ]
                ),
                flet.Row(
                    [
                        create_button("4"),
                        create_button("5"),
                        create_button("6"),
                        create_button("*"),
                    ]
                ),
                flet.Row(
                    [
                        create_button("1"),
                        create_button("2"),
                        create_button("3"),
                        create_button("-"),
                    ]
                ),
                flet.Row(
                    [
                        create_button("0"),
                        create_button("."),
                        flet.ElevatedButton("=", on_click=equal_click, width=70),
                        create_button("+"),
                    ]
                ),
                flet.Row([flet.ElevatedButton("C", on_click=clear_click, width=300)]),
            ],
            alignment=flet.MainAxisAlignment.CENTER,
            horizontal_alignment=flet.CrossAxisAlignment.CENTER,
        )
    )


flet.app(target=main)
