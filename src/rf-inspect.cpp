#include <iostream>
#include <iomanip>
#include <string>
#include "random_forest_test.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		cout << "rf-inspect pdbbind-2012-refined-core-x42.rf" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	f.load(argv[1]);

	// Inspect the forest.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(4);
	for (const auto& t : f)
	{
		for (const auto& n : t)
		{
			if (!n.children[0]) continue;
			cout << n.var << ',' << n.val << endl;
		}
	}
}
