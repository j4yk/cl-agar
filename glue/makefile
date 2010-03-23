OBJ = static-functions.o macro-functions.o
CC = gcc -Wall
L = gcc -shared

libclagar-glue.so: $(OBJ)
	$(L) `agar-config --libs` -o libclagar-glue.so $(OBJ) 

%.o: %.c
	$(CC) `agar-config --cflags` -o $@ -c $<

install:
	install -d $(DESTDIR)/usr/local/lib
	install libclagar-glue.so $(DESTDIR)/usr/local/lib
