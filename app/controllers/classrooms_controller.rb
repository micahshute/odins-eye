class ClassroomsController < ApplicationController


    def new
        if authorize
            @user = current_user
            @classroom = Classroom.new
            4.times do 
                @classroom.tags.build
            end
            @tag_types = Tag.most_popular(10)
        end
    end

    def create
        if authorize
            @classroom = Classroom.new(classroom_params)
            @classroom.professor = current_user
            if @classroom.tags.all?{ |t| t.tag_type.validate }
                if @classroom.save
                    @classroom.topics.build(title: "Student Lounge", user: @classroom.professor)
                    @classroom.topics.build(title: "Announcements", user: @classroom.professor)
                    @classroom.save
                    flash[:success] = "Congratulations, your classroom was created"
                    redirect_to user_classroom_path(current_user, @classroom)
                else
                    @tag_types = Tag.most_popular(10)
                    needed_tags = 4 - @classroom.tags.length
                    needed_tags.times do 
                        @classroom.tags.build
                    end
                    flash[:danger] = "#{@classroom.user.name}, there was a problem creating your classroom"
                    render 'new'
                end
            else
                @tag_types = Tag.most_popular(10)
                needed_tags = 4 - @classroom.tags.length
                needed_tags.times do 
                    @classroom.tags.build
                end
                flash[:danger] = "#{@classroom.user.name}, there was a problem creating your classroomc"
                render 'new'
            end
        end
    end

    def show   
        @classroom = Classroom.find(params[:id])
        if logged_in?
            @is_enrolled = current_user.enrolled_in?(@classroom)
            @is_professor = current_user.classrooms.include?(@classroom)
        else
            @is_enrolled = false
            @is_professor = false
        end
    end

    def edit
        @classroom = Classroom.find(params[:id])
        authorize(@classroom.professor)
    end

    def index
        @public_classrooms = Classroom.all_public
        @private_classrooms = Classroom.all_private
    end

    def update
        @classroom = Classroom.find(params[:id])
        authorize(@classroom.professor)
    end

    def destroy
        @classroom = Classroom.find(params[:id])
        authorize(@classroom.professor)
        @classroom.destroy
        redirect_to root_path
    end

    def students
        @classroom = Classroom.find(params[:id])
        authorize_classroom_entry(@classroom)
        @students = @classroom.students
        @is_enrolled = current_user.enrolled_in?(@classroom)
        @is_professor = current_user.classrooms.include?(@classroom)
        @users = User.all
    end

    def find_student
        professor = User.find(params[:user_id])
        classroom = Classroom.find(params[:id])
        authorize(professor)
        user_email = params[:user].split("::").last.strip
        if (new_student = User.find_by(email: user_email))
            new_student.enroll_in(classroom) unless new_student.enrolled_in?(classroom)
            redirect_to classroom_students_path(professor, classroom)
        else    
            not_found
        end
    end

    def destroy_student
        classroom = Classroom.find(params[:classroom_id])
        student = User.find(params[:id])
        authorize(classroom.professor)
        classroom.users.delete(student)
        redirect_to classroom_students_path(classroom.professor, classroom)
    end

 
    private

    def classroom_params
        params.require(:classroom).permit(
        [:name, tags_attributes: [
                :tag_type_name
            ]
        ])
    end
    
end