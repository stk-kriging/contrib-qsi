function bool = check_constraints_trajs(tensor_dn,traj_ind,var,lambda_pt,const)

delta = var-traj_ind;
tensor = tensor_dn + bsxfun(@times, lambda_pt, delta); %add lambda*delta to complete condt
bool = ((tensor >= const(1)) & (tensor <= const(2)));

end
