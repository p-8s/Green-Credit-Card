#test performance of random forest on test dataset

library(ggplot2)
library(glmnet)
library(tidyverse)
library(randomForest)
library(ROCR)

tag_test <- read.csv("../data/test_tag.csv")
dim(tag_test)[1]
colnames(tag_test)
rdm.index <- sample(dim(tag_test)[1], size=6)
tag_test[rdm.index,]
summary(tag_test)


## 1.1 Data cleaning and prepocessing
#put categorical variables as fators
tag_test[c(2,3,5,6,7,8,10,11,12,13,14,15,16,18,30,35,37)] <- lapply(tag_test[c(2,3,5,6,7,8,10,11,12,13,14,15,16,18,30,35,37)], as.factor)


#try to remove -1
colnames(tag_test)
neg_col_index <- c(17, 19, 20, 23, 24, 34, 38, 42)
dat_test <- tag_test
for (i in 1:8) {
  dat_test <- subset(dat_test, dat_test[neg_col_index[i]] != -1)
}

dim(dat_test) 
dim(tag_test)


#remove rows with -1 in cur_credit_min_opn_dt_cnt
dat_test1 <- subset(tag_test, cur_credit_min_opn_dt_cnt != -1)

#remove -1 in hld_crd_card_grd_cd
dat_test1 <- subset(dat_test1, hld_crd_card_grd_cd != -1)

#remove -1 in perm_crd_lmt_cd
dat_test1 <- subset(dat_test1, perm_crd_lmt_cd != -1)

#remove frs_agn_dt_cnt
dat_test1 <- subset(dat_test1, select = - frs_agn_dt_cnt)

#code the variable as a factor
dat_test1$fin_rsk_ases_grd_cd <- as.factor(dat_test1$fin_rsk_ases_grd_cd)

#code the variable as a factor
dat_test1$confirm_rsk_ases_lvl_typ_cd <- as.factor(dat_test1$confirm_rsk_ases_lvl_typ_cd)

#code the variable as a factor
dat_test1$tot_ast_lvl_cd <- as.factor(dat_test1$tot_ast_lvl_cd)

#code the variable as a factor
dat_test1$pot_ast_lvl_cd <- as.factor(dat_test1$pot_ast_lvl_cd)

#code "" levels as "-1"
levels(tag_test$atdd_type) <- c("-1", "-1", "0", "1")
levels(tag_test$deg_cd) <- c("-1",  "~", "A", "B", "C", "D", "E", "Z")
levels(tag_test$edu_deg_cd) <- c("-1",  "~", "A", "B", "C", "D", "E", "F", "G", "J", "K", "L", "M", "Z")


#define Good as customers who never default
dat_test1$good <- ifelse(dat_test1$his_lng_ovd_day == 0, 1, 0) #Good as 1, Bad as 0

#subset our target group
dat_test.t <- subset(dat_test1, age<=35 & gdr_cd=="F" & mrg_situ_cd=="B", select = -c(age, gdr_cd, mrg_situ_cd))
dim(dat_test.t)
summary(dat_test.t)

#drop levels
dat_test.t <- droplevels(dat_test.t)

#select variables which reflect customer background and behaviour
dat_test.tf <- subset(dat_test.t, select = c(cur_debit_cnt, cur_credit_cnt, cur_debit_min_opn_dt_cnt, cur_credit_min_opn_dt_cnt, cur_debit_crd_lvl, hld_crd_card_grd_cd, crd_card_act_ind, l1y_crd_card_csm_amt_dlm_cd, atdd_type, perm_crd_lmt_cd, acdm_deg_cd, job_year, ic_ind, fr_or_sh_ind,
dnl_bind_cmb_lif_ind,
hav_car_grp_ind,
hav_hou_grp_ind,
l6mon_daim_aum_cd,
tot_ast_lvl_cd,
pot_ast_lvl_cd,
l12mon_buy_fin_mng_whl_tms,
l12_mon_fnd_buy_whl_tms,
l12_mon_insu_buy_whl_tms,
l12_mon_gld_buy_whl_tms,
loan_act_ind,
pl_crd_lmt_cd,
good))


