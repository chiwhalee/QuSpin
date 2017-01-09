cdef state_type make_t_pz_basis_template(shifter shift,bitop fliplr,bitop flip_all,ns_type next_state,
											state_type MAX,state_type s,
											int L,int pzblock,int kblock,int a,
											NP_INT8_t*N,NP_INT8_t*m,basis_type*basis):
	cdef double k 
	
	cdef state_type Ns
	cdef state_type i
	cdef int sigma,sigma_i,sigma_f
	cdef NP_INT8_t r_temp,r,mpz
	cdef _np.ndarray[NP_INT8_t,ndim=1] R = _np.zeros(2,dtype=NP_INT8)
	cdef int j
	
	k = 2.0*_np.pi*kblock*a/L

	if (2*kblock*a) % L == 0: #picks up k = 0, pi modes
		sigma_i = 1
		sigma_f = 1
	else:
		sigma_i = -1
		sigma_f = 1

	Ns = 0
	for i in range(MAX):
		CheckState_T_PZ_template(shift,fliplr,flip_all,kblock,L,s,a,R)
		r = R[0]
		mpz = R[1]
		if r > 0:
			if mpz != -1:
				for sigma in range(sigma_i,sigma_f+1,2):
					r_temp = r
					if 1 + sigma*pzblock*cos(mpz*k) == 0:
						r_temp = -1
					if (sigma == -1) and (1 - sigma*pzblock*cos(mpz*k) != 0):
						r_temp = -1
	
					if r_temp > 0:
						m[Ns] = mpz
						N[Ns] = (sigma*r)				
						basis[Ns] = s
						Ns += 1
			else:
				for sigma in range(sigma_i,sigma_f+1,2):
					m[Ns] = -1
					N[Ns] = (sigma*r)				
					basis[Ns] = s
					Ns += 1

		s = next_state(s)

	return Ns
