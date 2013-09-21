CC=g++ -std=c++0x -O3

all: rf-train rf-score

rf-train: random_forest.o rf-train.o
	$(CC) -o $@ $^ -pthread

rf-score: random_forest.o rf-score.o
	$(CC) -o $@ $^

%.o: %.cpp
	$(CC) -o $@ $< -c

clean:
	rm -f rf-score rf-train *.o
