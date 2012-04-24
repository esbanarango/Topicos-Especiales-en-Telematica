/*
	Esteban Arango Medina
	Ejecución algoritmos en paralelo.

	"Encontrar una subcadena en otra cadena mas larga"
*/

#include <iostream>
#include <string>
#include <vector>
using namespace std;
typedef vector <int> vi;

vi fSubCadena(string cadena, string subC){
	vi resp;
	string temp;
	int sizeCadena = cadena.size();
	int sizeSubCadena = subC.size();
	for (int i = 0; i < sizeCadena; ++i)
	{
		if(sizeCadena-i>=sizeSubCadena){
			temp = cadena.substr(i,sizeSubCadena);
			if(temp==subC)
				resp.push_back(i);
		}else{
			break;
		}
	}
	return resp;
}


int main(){
	string cadena = "AAGAGCGGAGAGAG";
	string subCadena="AG";
	vi posiciones = fSubCadena(cadena,subCadena);
	cout<<"Cadena: '"<<cadena<<"'"<<endl;
	cout<<"SubCadena: '"<<subCadena<<"'"<<endl;
	printf("Posiciones:\n\t");
	for (int i = 0; i < posiciones.size(); ++i)
	{
		printf("%d ",posiciones[i]);
	}
	printf("\n");
	return 0;
}