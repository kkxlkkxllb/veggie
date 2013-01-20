module CourseHelper
  def course_index_title
    name = current_member ? "#{current_member.name}'s " : ""
    "#{name}Major Course"
  end
end
