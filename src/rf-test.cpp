#include <iostream>
#include <iomanip>
#include <string>
#include "random_forest_test.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 3)
	{
		cout << "rf-test pdbbind-2012-refined-core-x42.rf pdbbind-2012-core-yx42i.csv" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	f.load(argv[1]);

	// Parse testing samples and predict RF-Score.
	cout.setf(ios::fixed, ios::floatfield);
	cout << "PDB,pbindaff,predicted" << endl << setprecision(2);
	string line;
	ifstream ifs(argv[2]);
	getline(ifs, line);
	while (getline(ifs, line))
	{
		size_t c0 = line.find(',');
		const auto y = stof(line.substr(0, c0));
		vector<float> v;
		v.reserve(36);
		while (true)
		{
			const size_t c1 = line.find(',', c0 + 2);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(c0 + 1, c1 - c0 - 1)));
			c0 = c1;
		}
		const auto p = f(v);
		cout << line.substr(c0 + 1) << ',' << y << ',' << p << endl;
	}
}
