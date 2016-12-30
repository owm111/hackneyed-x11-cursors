CFLAGS += -std=c99 -Wall -Werror -pedantic -g
SOURCES = ico2cur.c
EXECUTABLE = ico2cur
OBJECTS = $(SOURCES:.c=.o)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(EXECUTABLE): $(OBJECTS)
	$(CC) -o $(EXECUTABLE) $(OBJECTS) $(LDFLAGS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
