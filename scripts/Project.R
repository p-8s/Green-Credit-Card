# rough work
# take_fn <- function (r, p ) {
#   3 - 10*r - 2*p
# } #assumption borrowed from So et al
# 
# prof_ptf <- function (r, P) {
#   e_list = c()
#   p_opt <- ((1-m) * (1+r_F)^N / (l_D * (1+r)^(N-1)) + (l_D-1)/l_D)^(1/N)
#   integrand <- function(p) {ind_exp_prof(r, p, P) * take_fn(r, p) * (4*p - 2)}
#   ans = integrate(integrand, lower=p_opt, upper=1)
#   return(ans)
# }
# 
# 
# prof_ptf(r=r0, P=590)
