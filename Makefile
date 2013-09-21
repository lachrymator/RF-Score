CC=g++ -std=c++0x -O3

rf: random_forest.o main.o
	$(CC) -o $@ $^ -pthread

%.o: %.cpp
	$(CC) -o $@ $< -c

clean:
	rm -f rf *.o
