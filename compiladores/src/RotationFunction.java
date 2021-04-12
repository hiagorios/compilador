public class RotationFunction {

    /* As matrizes R e Q são geradas a partir da função de rotação
    * randômica, adotando-se um seed de 13 para R e um seed de
    * 10^6 para a função Q, ou seja, a mesma função é usada para ambas,
    mudando-se apenas os argumentos passados como parâmetros. */

    public static double[][] cocoRandUniforme(int dim, long inseed) {
        double[][] r = new double[1][dim];
//        double[][] r = new double[dim][dim];
//        for (int i = 0; i < dim; i++) {
//            for (int j = 0; j < dim; j++) {
//                r[i][j] = 1;
//            }
//        }

        long aktseed;
        int tmp;
        long[] rgrand = new long[32];
        long aktrand;
        int i;

        if (inseed < 0)
            inseed = -inseed;
        if (inseed < 1)
            inseed = 1;
        aktseed = inseed;
        for (i = 39; i >= 0; i--) {
            tmp = (int) Math.floor((double) aktseed / (double) 127773);
            aktseed = 16807 * (aktseed - tmp * 127773L) - 2836L * tmp;
            if (aktseed < 0)
                aktseed = aktseed + 2147483647;
            if (i < 32)
                rgrand[i] = aktseed;
        }
        aktrand = rgrand[0];
        for (i = 0; i < dim; i++) {
            tmp = (int) Math.floor((double) aktseed / (double) 127773);
            aktseed = 16807 * (aktseed - tmp * 127773L) - 2836L * tmp;
            if (aktseed < 0)
                aktseed = aktseed + 2147483647;
            tmp = (int) Math.floor((double) aktrand / (double) 67108865);
            aktrand = rgrand[tmp];
            rgrand[tmp] = aktseed;
            r[0][i] = (double) aktrand / 2.147483647e9;
            if (r[0][i] == 0.) {
                r[0][i] = 1e-99;
            }
        }
        return r;
    }
}
