void kernel_main(void)
{
        char* video = (char*) 0xB8000;
        video[0] = 'C';
        video[1] = 0x07;
}