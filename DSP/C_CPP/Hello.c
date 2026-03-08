#include <windows.h>

int WINAPI WinMain(
    HINSTANCE hInstance,
    HINSTANCE hPreinstance,
    LPSTR LpCmdLine,
    int nCmdShow)
{
    MessageBox(
        GetFocus(),
        "Hello.",
        "Message",
        MB_OK);
    return 0;
}