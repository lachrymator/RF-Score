#include <sstream>
#include "random_forest_test.hpp"

void node::load(istream& is)
{
	unsigned int var;
	unsigned int c0;
	unsigned int c1;
	is.read((char*)&y, 4);
	is.read((char*)&var, 4);
	is.read((char*)&val, 4);
	is.read((char*)&c0, 4);
	is.read((char*)&c1, 4);
	this->var = var;
	this->children[0] = c0;
	this->children[1] = c1;
}

void tree::load(istream& is)
{
	unsigned int nn;
	is.read((char*)&nn, 4);
	resize(nn);
	for (auto& n : *this)
	{
		n.load(is);
	}
}

float tree::operator()(const vector<float>& x) const
{
	size_t k;
	for (k = 0; (*this)[k].children[0]; k = (*this)[k].children[x[(*this)[k].var] > (*this)[k].val]);
	return (*this)[k].y;
}

void forest::load(const string& path)
{
	ifstream ifs(path, ios::binary);
	load(ifs);
}

void forest::load(istream& is)
{
	unsigned int nt;
	is.read((char*)&nt, 4);
	resize(nt);
	for (auto& t : *this)
	{
		t.load(is);
	}
	nt_inv = 1.0f / nt;
}

float forest::operator()(const vector<float>& x) const
{
	float y = 0;
	for (const tree& t : *this)
	{
		y += t(x);
	}
	return y *= nt_inv;
}
