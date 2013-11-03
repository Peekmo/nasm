unsigned char port_byte_in(unsigned short port)
{
	// "=a" (result) => put in result
	unsigned char result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

void port_byte_out(unsigned short port, unsigned char data)
{
	// load EAX with data => "a"(data)
	// load EDX with port => "d"(port)
	__asm__("out %%al, %%dx" : :"a" (data), "d" (port));
}

unsigned short port_word_in(unsigned short port)
{
	// "=a" (result) => put in result
	unsigned char result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

void port_word_out(unsigned short port, unsigned short data)
{
	// load EAX with data => "a"(data)
	// load EDX with port => "d"(port)
	__asm__("out %%al, %%dx" : :"a" (data), "d" (port));
}
