#include <iostream>
#include <iomanip>
#include <string>
#include "random_forest_test.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		cout << "rf-predict pdbbind-2012-refined-core-x42.rf" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	f.load(argv[1]);

	// Load a receptor and multiple conformations of a ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(2);
	for (string line; getline(cin, line);)
	{
		vector<float> v;
		v.reserve(36);
		size_t p0 = 0;
		while (true)
		{
			const size_t c1 = line.find(',', p0 + 1);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(p0, c1 - p0)));
			p0 = c1 + 1;
		}
		v.push_back(stof(line.substr(p0)));
		cout << f(v) << endl;
	}
}
