import tensorflow as tf
import numpy      as np
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

print("##Example : using numpy function")
arr   = [1,2,3,4]
print("arr = " + str(arr))
print("mean: np.mean(arr) = " + str(np.mean(arr)))
print("variance : np.var(arr) = " + str(np.var(arr)))
print("standard deviation : np.std(arr) = " + str(np.std(arr)))
print("sample standard deviation : np.std(arr,ddof=1) = " + str(np.std(arr,ddof=1)))
print("covariance : np.cov(arr) = " + str(np.cov(arr)))

