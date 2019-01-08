#include "matrix.h"

Matrix::Matrix()
{

}

QVector<QVector<float>> Matrix::dot(QVector<QVector<float> > mat_a, QVector<QVector<float> > mat_b)
{
    QVector<QVector<float>> res(mat_a.length());

    if (mat_a[0].length() != mat_b.length()) {
        qDebug() << "matrix.cpp: The columns of the first matrix must be equal to the rows of the second matrix";
        return res;
    }

    /*qDebug() << "matrix.cpp: mat_a:" << mat_a;
    qDebug() << "matrix.cpp: mat_b:" << mat_b;*/

    for (int index_rowA = 0; index_rowA < mat_a.length(); index_rowA++) {
        QVector<float> res_row(mat_b[0].length());
        QVector<float> rowA = mat_a[index_rowA];

        for (int index_colB = 0; index_colB < mat_b[0].length(); index_colB++) {
            float summation = 0;

            for (int index = 0; index < rowA.length(); index++) {
                summation += (rowA[index] * mat_b[index][index_colB]);
            }

            res_row[index_colB] = summation;
        }

        res[index_rowA] = res_row;
    }

    return res;
}

QVector<QVector<float> > Matrix::add(QVector<QVector<float> > mat_a, QVector<QVector<float> > mat_b)
{
    QVector<QVector<float>> res(mat_a.length());

    for (int index_rowA = 0; index_rowA < mat_a.length(); index_rowA++) {
        QVector<float> res_row(mat_b[0].length()); // could be mat_a[0].length as they are of equal dimensions
        QVector<float> rowA = mat_a[index_rowA];

        for (int index = 0; index < rowA.length(); index++) {
            res_row[index] = rowA[index] + mat_b[index_rowA][index];
        }

        res[index_rowA] = res_row;
    }

    return res;
}

QVector<QVector<float> > Matrix::subtract(QVector<QVector<float> > mat_a, QVector<QVector<float> > mat_b)
{
    QVector<QVector<float>> res(mat_a.length());

    for (int index_rowA = 0; index_rowA < mat_a.length(); index_rowA++) {
        QVector<float> res_row(mat_b[0].length()); // could be mat_a[0].length as they are of equal dimensions
        QVector<float> rowA = mat_a[index_rowA];

        for (int index = 0; index < rowA.length(); index++) {
            res_row[index] = rowA[index] - mat_b[index_rowA][index];
        }

        res[index_rowA] = res_row;
    }

    return res;
}

QVector<QVector<float> > Matrix::multiply(QVector<QVector<float> > mat_a, QVector<QVector<float> > mat_b)
{
    QVector<QVector<float>> res(mat_a.length());

    for (int index_rowA = 0; index_rowA < mat_a.length(); index_rowA++) {
        QVector<float> res_row(mat_b[0].length()); // could be mat_a[0].length as they are of equal dimensions
        QVector<float> rowA = mat_a[index_rowA];

        for (int index = 0; index < rowA.length(); index++) {
            res_row[index] = rowA[index] * mat_b[index_rowA][index];
        }

        res[index_rowA] = res_row;
    }

    return res;
}

QVector<QVector<float> > Matrix::transpose(QVector<QVector<float> > mat)
{
    QVector<QVector<float>> transposed(mat[0].length());

    for (int index = 0; index < transposed.length(); index++) {
        QVector<float> row(mat.length());
        transposed[index] = row;
    }

    for (int rowIndex = 0; rowIndex < mat.length(); rowIndex++) {
        QVector<float> row = mat[rowIndex];

        for (int index = 0; index < row.length(); index++) {
            transposed[index][rowIndex] = row[index];
        }
    }

    return transposed;
}
