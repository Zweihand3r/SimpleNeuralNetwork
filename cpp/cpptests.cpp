#include "cpptests.h"

CppTests::CppTests(QObject *parent) : QObject(parent)
{

}

CppTests::CppTests(Neural *neural)
{
    m_neural = neural;
}

QVector<QVector<float> > CppTests::toVector(const QStringList stringList)
{
    QVector<QVector<float>> vector;
    for (QString rowStr : stringList) {
        QStringList rowElements = rowStr.split(" ");
        QVector<float> row;

        for (QString element : rowElements) {
            row.push_back(element.toFloat());
        }

        vector.push_back(row);
    }

    return vector;
}

QStringList CppTests::toStringList(const QVector<QVector<float> > vector)
{
    QStringList stringList;
    for (QVector<float> row : vector) {
        QString rowStr = "";

        for (int index = 0; index < row.length(); index++) {
            if (index > 0) rowStr += " ";
            rowStr += QString::number(row[index]);
        }

        stringList << rowStr;
    }

    return stringList;
}

QStringList CppTests::testDot(QStringList str_a, QStringList str_b)
{
    QVector<QVector<float>> mat_a = toVector(str_a);
    QVector<QVector<float>> mat_b = toVector(str_b);

    qDebug() << "cpptests.cpp: testDot > mat_a:" << mat_a;
    qDebug() << "cpptests.cpp: testDot > mat_b:" << mat_b;

    QVector<QVector<float>> res = Matrix::dot(mat_a, mat_b);

    QStringList resStr = toStringList(res);
    return resStr;
}

QStringList CppTests::testBasicOperation(QStringList str_a, QStringList str_b, int opIndex)
{
    QVector<QVector<float>> mat_a = toVector(str_a);
    QVector<QVector<float>> mat_b = toVector(str_b);

    QVector<QVector<float>> res;
    switch (opIndex) {
    case 0: res = Matrix::add(mat_a, mat_b); break;
    case 1: res = Matrix::subtract(mat_a, mat_b); break;
    case 2: res = Matrix::multiply(mat_a, mat_b); break;
    default: break;
    }

    QStringList resStr = toStringList(res);
    return resStr;
}

QStringList CppTests::testTranspose(QStringList str)
{
    QVector<QVector<float>> mat = toVector(str);
    QVector<QVector<float>> transposed = Matrix::transpose(mat);

    QStringList transposedStr = toStringList(transposed);
    return transposedStr;
}

void CppTests::testSlightlyHarder()
{
    QVector<QVector<float>> X = toVector({
                                             "0 0 1",
                                             "0 1 1",
                                             "1 0 1",
                                             "1 1 1"
                                         });

    QVector<QVector<float>> y = toVector({
                                             "0",
                                             "1",
                                             "1",
                                             "0"
                                         });

    qDebug() << "Input:" << X;
    qDebug() << "Output:" << y;

    /*QVector<QVector<float>> syn0 = m_neural->getRandomisedWeights(3, 4);
    QVector<QVector<float>> syn1 = m_neural->getRandomisedWeights(4, 1);*/

    QVector<QVector<float>> syn0 = toVector({
                                                "0.1 0.3 -0.25 0.2",
                                                "-0.4 0.2 -0.3 0.12",
                                                "0.125 -0.7 -0.12 0.4"
                                            });
    QVector<QVector<float>> syn1 = toVector({
                                                "0.24",
                                                "-0.14",
                                                "0.4",
                                                "-0.6"
                                            });

    qDebug() << "cpptests.cpp: syn0:" << syn0;
    qDebug() << "cpptests.cpp: syn1:" << syn1;

    QVector<QVector<float>> l0 = X;
    QVector<QVector<float>> l1;
    QVector<QVector<float>> l2;

    for (int index = 0; index < 10000; index++) {
        l1 = m_neural->getSigmoid(Matrix::dot(l0, syn0));
//        qDebug() << "cpptests.cpp: l1:" << l1;

        l2 = m_neural->getSigmoid(Matrix::dot(l1, syn1));
//        qDebug() << "cpptests.cpp: l2:" << l2;

        QVector<QVector<float>> l2_error = Matrix::subtract(y, l2);
//        qDebug() << "cpptests.cpp: l2_error:" << l2_error;

        QVector<QVector<float>> l2_delta = Matrix::multiply(l2_error, m_neural->getSigmoidDerivative(l2));
//        qDebug() << "cpptests.cpp: l2_delta:" << l2_delta;

        QVector<QVector<float>> l1_error = Matrix::dot(l2_delta, Matrix::transpose(syn1));
//        qDebug() << "cpptests.cpp: l1_error:" << l1_error;

        QVector<QVector<float>> l1_delta = Matrix::multiply(l1_error, m_neural->getSigmoidDerivative(l1));
//        qDebug() << "cpptests.cpp: l1_delta:" << l1_delta;

        syn1 = Matrix::add(syn1, Matrix::dot(Matrix::transpose(l1), l2_delta));
        syn0 = Matrix::add(syn0, Matrix::dot(Matrix::transpose(l0), l1_delta));

//        qDebug() << "cpptests.cpp: syn0:" << syn0;
//        qDebug() << "cpptests.cpp: syn1:" << syn1;
    }

    QVector<QVector<float>> testIn = toVector({
                                                  "0 1 1"
                                              });

    l1 = m_neural->getSigmoid(Matrix::dot(testIn, syn0));
    l2 = m_neural->getSigmoid(Matrix::dot(l1, syn1));

    qDebug() << l2;
}

QVector<qreal> CppTests::dataTest(QVector<qreal> arr)
{
    /* This works. 2d arrays dont. Only for qreal not float */
    qDebug() << arr;
    return arr;
}
