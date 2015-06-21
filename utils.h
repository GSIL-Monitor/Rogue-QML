#ifndef UTILS_H
#define UTILS_H
#include <QStringList>
#include <QList>
#include <QVariant>

//-------------------Random-------------------
static int random(int min, int max){ return min+qrand()/(RAND_MAX/(max-min+1)+1);}


#endif // UTILS_H
