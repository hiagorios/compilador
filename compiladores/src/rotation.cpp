// Reescrito para C++ por Paulo André S. Giacomin
// com partes extraidas da plataforma COCO da GECCO.

/* As matrizes R e Q são geradas a partir da função de rotação
 * randômica, adotando-se um seed de 13 para R e um seed de
 * 10^6 para a função Q, ou seja, a mesma função é usada para ambas,
   mudando-se apenas os argumentos passados como parâmetros. */

template<typename T>
Matrix<T> coco_rand_uniforme(int dim, long inseed){

    Matrix<T> r(1, dim);

    long aktseed;
    long tmp;
    long rgrand[32];
    long aktrand;
    long i;

    if (inseed < 0)
      inseed = -inseed;
    if (inseed < 1)
      inseed = 1;
    aktseed = inseed;
    for (i = 39; i >= 0; i--) {
      tmp = (int) floor((double) aktseed / (double) 127773);
      aktseed = 16807 * (aktseed - tmp * 127773) - 2836 * tmp;
      if (aktseed < 0)
        aktseed = aktseed + 2147483647;
      if (i < 32)
        rgrand[i] = aktseed;
    }
    aktrand = rgrand[0];
    for (i = 0; i < dim; i++) {
      tmp = (int) floor((double) aktseed / (double) 127773);
      aktseed = 16807 * (aktseed - tmp * 127773) - 2836 * tmp;
      if (aktseed < 0)
        aktseed = aktseed + 2147483647;
      tmp = (int) floor((double) aktrand / (double) 67108865);
      aktrand = rgrand[tmp];
      rgrand[tmp] = aktseed;
      r[0][i] = (double) aktrand / 2.147483647e9;
      if (r[0][i] == 0.) {
        r[0][i] = 1e-99;
      }
    }
    return r;
}