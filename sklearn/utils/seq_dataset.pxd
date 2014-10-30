"""Dataset abstractions for sequential data access. """

cimport numpy as np

# SequentialDataset and its two concrete subclasses are (optionally randomized)
# iterators over the rows of a matrix X and corresponding target values y.

cdef class SequentialDataset:
    cdef int current_index
    cdef np.ndarray index
    cdef int *index_data_ptr
    cdef Py_ssize_t n_samples

    cdef void next(self, double **x_data_ptr, int **x_ind_ptr,
                   int *nnz, double *y, double *sample_weight) nogil
    cdef void shuffle(self, np.uint32_t seed) nogil
    cdef int _get_next_index(self) nogil
    cdef int _get_random_index(self) nogil

    cdef void _sample(self, double **x_data_ptr, int **x_ind_ptr,
                      int *nnz, double *y, double *sample_weight,
                      int current_index) nogil
    cdef int random(self, double **x_data_ptr, int **x_ind_ptr,
                    int *nnz, double *y, double *sample_weight) nogil


cdef class ArrayDataset(SequentialDataset):
    cdef Py_ssize_t n_features
    cdef int stride
    cdef double *X_data_ptr
    cdef double *Y_data_ptr
    cdef np.ndarray feature_indices
    cdef int *feature_indices_ptr
    cdef double *sample_weight_data

cdef class CSRDataset(SequentialDataset):
    cdef int stride
    cdef double *X_data_ptr
    cdef int *X_indptr_ptr
    cdef int *X_indices_ptr
    cdef double *Y_data_ptr
    cdef np.ndarray feature_indices
    cdef int *feature_indices_ptr
    cdef double *sample_weight_data
