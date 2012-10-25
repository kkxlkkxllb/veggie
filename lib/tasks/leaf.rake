# coding: utf-8 
namespace :leaf do
  
  desc "grow leafs every day"
  task :grow => :environment do
		Provider.build_leaf
		num = Leaf.where(["created_at > ?",Date.today - 8.hour]).count
		Leaf.logger.info("#{Date.today.to_s} Auto grow #{num} leafs today!")
		#send to sns
		HardWorker::SendNewLeafReport.perform_async(num)

  end

end
