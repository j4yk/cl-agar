OBJ = static-functions.o macro-functions.o
CC = gcc -Wall
L = gcc -shared

all: $(OBJ)
	$(L) `agar-config --libs` -o libagar-glue.so $(OBJ) 

%.o: %.c
	$(CC) `agar-config --cflags` -o $@ -c $<
