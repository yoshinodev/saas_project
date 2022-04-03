class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :plan
  has_one :profile
  
attr_accessor :stripe_card_token
# If user passes validation (email, password, etc)
# then call stripe and tell stripe to set up a subscription
# upon charging the customer card.
# Stripe responds back with customer data.
# We store customer.id as the customer token and save the user.
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      subscription = Stripe::Subscription.create(
      customer: customer.id, 
      items: [{
      plan: 'price_1Kj5s0E17XeWbTUEEc1q9NqT' # the plan or price ID from dashboard.stripe.com
      }]
      )
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
