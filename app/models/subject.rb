#encoding: utf-8

class Subject < ActiveRecord::Base
  belongs_to :grade
end
