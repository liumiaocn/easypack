import tensorflow as tf
import numpy  as np
import pandas as pd
import os
import csv
from sklearn import datasets

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

IRIS_TEST = "iris_test.csv"

print("##Example 1: csv file read: tf.contrib.learn.datasets.base.load_csv_with_header")
print("  filename: " + IRIS_TEST)
test_set = tf.contrib.learn.datasets.base.load_csv_with_header(
    filename=IRIS_TEST,
    target_dtype=np.int,
    features_dtype=np.float32)
print test_set 


print("\n##Example 2: csv file read: tf.data.TextLineDataset + make_one_shot_iterator")
print("  filename: " + IRIS_TEST)
datafiles = [IRIS_TEST]
#dataset = tf.data.TextLineDataset(IRIS_TEST)
dataset = tf.data.TextLineDataset(datafiles)
iterator = dataset.make_one_shot_iterator()

with tf.Session() as sess:
  for i in range(5):
    print(sess.run(iterator.get_next()))


print("\n##Example 3: iris dataset load:  datasets.load_iris")
dataset =  datasets.load_iris()
data    =  dataset.data[:,:4]
print(data)

print("\n##Example 4: csv module: ")
print("  filename: " + IRIS_TEST)
with open(IRIS_TEST,'r') as csvfile:
  csvdata= csv.reader(csvfile)
  for line in csvdata:
    print line

print("\n##Example 5: pandas module: ")
print("  filename: " + IRIS_TEST)
csvdata = pd.read_csv(IRIS_TEST)
print("Shape of the data:" + str(csvdata.shape))
print(csvdata)
