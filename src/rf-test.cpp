#include <iostream>
#include <iomanip>
#include <string>
#include "random_forest_test.hpp"
#include "statistics.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc != 4)
	{
		cout << "Usage: rf-test pdbbind2012-refined-core-x42.rf pdbbind2012-core-yx42i.csv pdbbind2012-core-iyp.csv" << endl;
		return 0;
	}

	// Load a random forest from file.
	forest f;
	f.load(argv[1]);

	// Parse testing samples, predict RF-Score and write output to file.
	string line;
	vector<float> p;
	p.reserve(195);
	vector<float> y;
	y.reserve(p.capacity());
	vector<float> v;
	ifstream tstifs(argv[2]);
	getline(tstifs, line);
	ofstream prdofs(argv[3]);
	prdofs.setf(ios::fixed, ios::floatfield);
	prdofs << "PDB,RF-Score,pbindaff" << endl << setprecision(2);
	while (getline(tstifs, line))
	{
		size_t c0 = line.find(',');
		y.push_back(stof(line.substr(0, c0)));
		vector<float> v;
		v.reserve(36);
		while (true)
		{
			const size_t c1 = line.find(',', c0 + 2);
			if (c1 == string::npos) break;
			v.push_back(stof(line.substr(c0 + 1, c1 - c0 - 1)));
			c0 = c1;
		}
		p.push_back(f(v));
		prdofs << line.substr(c0 + 1) << ',' << p.back() << ',' << y.back() << endl;
	}
	prdofs.close();
	tstifs.close();

	// Evaluate prediction performance on testing samples.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(3);
	stats(p, y);
}
