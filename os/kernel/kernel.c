void m() {}

int main()
{
	char *memory_video = (char*)0xB8000;
	*memory_video = 'X';
}
