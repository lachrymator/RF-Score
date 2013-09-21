CC=g++ -std=c++0x -O3

all: rf-train rf-test rf-score

rf-train: random_forest_train.o rf-train.o
	$(CC) -o $@ $^ -pthread

rf-test: random_forest_test.o rf-test.o
	$(CC) -o $@ $^

rf-score: random_forest_test.o rf-score.o
	$(CC) -o $@ $^

%.o: %.cpp
	$(CC) -o $@ $< -c

clean:
	rm -f rf-score rf-test rf-train *.o
