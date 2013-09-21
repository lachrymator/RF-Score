#include "random_forest_test.hpp"

void node::load(ifstream& ifs)
{
	unsigned int var;
	unsigned int c0;
	unsigned int c1;
	ifs.read((char*)&y, 4);
	ifs.read((char*)&var, 4);
	ifs.read((char*)&val, 4);
	ifs.read((char*)&c0, 4);
	ifs.read((char*)&c1, 4);
	this->var = var;
	this->children[0] = c0;
	this->children[1] = c1;
}

void tree::load(ifstream& ifs)
{
	unsigned int nn;
	ifs.read((char*)&nn, 4);
	resize(nn);
	for (auto& n : *this)
	{
		n.load(ifs);
	}
}

float tree::operator()(const vector<float>& x) const
{
	size_t k;
	for (k = 0; (*this)[k].children[0]; k = (*this)[k].children[x[(*this)[k].var] > (*this)[k].val]);
	return (*this)[k].y;
}

void forest::load(ifstream& ifs)
{
	unsigned int nt;
	ifs.read((char*)&nt, 4);
	resize(nt);
	for (auto& t : *this)
	{
		t.load(ifs);
	}
}

float forest::operator()(const vector<float>& x) const
{
	float y = 0;
	for (const tree& t : *this)
	{
		y += t(x);
	}
	return y /= size();
}
