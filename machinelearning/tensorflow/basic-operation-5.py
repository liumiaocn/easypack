import tensorflow as tf
import os
from sklearn import datasets
import matplotlib.pyplot as plt

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

print("\n##iris dataset load:  datasets.load_iris")
data =  datasets.load_iris()
#print(data.DESCR)
#print(dir(data))
#print(data.data)
#print(data.feature_names)
#print(data.target)
#print(data.target_names)

feature = data.data
kind = data.target
xlable = data.feature_names[0]
ylable = data.feature_names[1]
title  = "Sepal: width vs length"
plt.plot(feature[:, 0][kind==0], feature[:, 1][kind==0], 'cx', label=data.target_names[0])
plt.plot(feature[:, 0][kind==1], feature[:, 1][kind==1], 'bx', label=data.target_names[1])
plt.plot(feature[:, 0][kind==2], feature[:, 1][kind==2], 'gx', label=data.target_names[2])
plt.xlabel(xlable)
plt.ylabel(ylable)
plt.title(title)
plt.legend()
plt.show()

xlable = data.feature_names[2]
ylable = data.feature_names[3]
title  = "Petal: width vs length"
plt.plot(feature[:, 2][kind==0], feature[:, 3][kind==0], 'cx', label=data.target_names[0])
plt.plot(feature[:, 2][kind==1], feature[:, 3][kind==1], 'bx', label=data.target_names[1])
plt.plot(feature[:, 2][kind==2], feature[:, 3][kind==2], 'gx', label=data.target_names[2])
plt.xlabel(xlable)
plt.ylabel(ylable)
plt.title(title)
plt.legend()
plt.show()


