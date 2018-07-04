#!/usr/bin/python

import glob
import os
import fileinput

#path where project data lives
path = '/u/project/blinded/data/blinded' #certain elements of the path have been blinded for review purposes

#list the subjects we want
subs = ['1001','1002','1005','1006','1007','1008','1031','1032','1034','1036','1072',
'1077','1078','1081','1089','1090','1091','1098','1105','1106','1111',
'1115','1116','1117','1118','1119','1125','1126','1127','1128','1132',
'1133','1134','1136','1142','1143','1145','1146','1147','1152','1153',
'1154','1157','1166','1167','1173','1176','1185','1195','1207','1208',
'1218','1226','1227','1228','1233','1237','1239','1240','1244','1245',
'1246','1248','1249','1250','1252','1253','1256','1262','1263'] 

#Create path to masks
maskdirs = glob.glob('%s/masks/expanded/*.nii.gz'%(path))


for sub in list(subs):
	dir = '%s/%s'%(path, sub) #set subject specific directory to imaging data
	sub = dir.split('/')[6]	#create variable with subject id for later string replacement
	print sub 
	#Following two lines transform subject T1 image into standard space, then segements using FAST
	os.system('flirt -in %s/anatomy/T1_brain.nii.gz -ref /u/project/CCN/apps/fsl/5.0.9/data/standard/MNI152_T1_2mm_brain -init %s/model/run1_lev1_mod1.feat/reg/highres2standard.mat -out %s/anatomy/T1_brain_std'%(dir, dir, dir))
	os.system('fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -o %s/anatomy/T1_brain_std %s/anatomy/T1_brain_std'%(dir, dir))
	#Loops over all 32 spheres, masks T1 and extracts gm composition estimates from each
	for mask in list(maskdirs):
		masklab = mask.split('/')[8][:-7]
		print masklab
		#Save gm composition estimate as a .txt
		os.system('fslmeants -i %s/anatomy/T1_brain_std_pve_1.nii.gz -m %s -o %s/anatomy/%s_gm.txt'%(dir, mask, dir, masklab))
	#remove clutter, save server space!
	os.system('rm %s/anatomy/*std*.nii.gz'%(dir))
	
	#read in .txts from all masks to one object, save as final output
	read_txt = glob.glob('%s/anatomy/*.txt'%(dir))
	read_txt.sort()
	with open('%s/anatomy/gm_spheres.txt'%(dir), 'w') as file:
		input_lines = fileinput.input(read_txt)
		file.writelines(input_lines)
	
	
	
