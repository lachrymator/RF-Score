#include <iostream>
#include <iomanip>
#include <string>
#include "statistics.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	vector<float> p, y;
	p.reserve(100);
	y.reserve(100);
	for (string line; getline(cin, line);)
	{
		size_t c = line.find(',');
		p.push_back(stof(line.substr(0, c)));
		y.push_back(stof(line.substr(c + 1)));
	}
	const auto s = stats(p, y);

	cout.setf(ios::fixed, ios::floatfield);
	cout << "n,rmse,sdev,pcor,scor,kcor" << endl << y.size() << ',' << setprecision(3) << s[0] << ',' << s[1] << ',' << s[2] << ',' << s[3] << ',' << s[4] << endl;
}
