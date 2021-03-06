module AuthorizationHelper
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    guest_user.books.each { |book| book.update(user_id: current_user.id) } if guest_user.books.present?
    guest_user.holsts.each { |holst| holst.update(user_id: current_user.id) } if guest_user.holsts.present?
  end

  def create_guest_user
    u = User.new(name: 'guest', email: "guest_#{Time.now.to_i}#{rand(100)}@gudvinfoto.ru", guest: true)
    u.save!(validate: false)
    session[:guest_user_id] = u.id
    u
  end
end
