require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Post. As you add validations to Post, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
        title: 'Event title',
        date: Time.now,
        description: 'Event description'
    }
  }

  let(:invalid_attributes) {
    {
        title: '',
        date: Time.now,
        description: ''
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PostsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    login_user
    it 'assigns all event as @posts' do
      event = Event.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:events).to_a).to eq([event])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event as @event' do
      event = Event.create! valid_attributes
      get :show, params: {id: post.to_param}, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe 'GET #new' do
    it 'assigns a new event as @event' do
      get :new, params: {}, session: valid_session
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested event as @event' do
      event = Event.create! valid_attributes
      get :edit, params: {id: event.to_param}, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe 'Event #create' do
    context 'with valid params' do
      it 'creates a new event' do
        expect {
          event :create, params: {event: valid_attributes}, session: valid_session
        }.to change(Event, :count).by(1)
      end

      it 'assigns a newly created event as @event' do
        event :create, params: {event: valid_attributes}, session: valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it 'redirects to the created event' do
        event :create, params: {event: valid_attributes}, session: valid_session
        expect(response).to redirect_to([:admin, Event.last])
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved event as @event' do
        event :create, params: {event: invalid_attributes}, session: valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        event :create, params: {event: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {
            title: 'Event title',
            date: Time.now,
            description: 'Event description'
        }
      }

      it 'updates the requested event' do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: new_attributes}, session: valid_session
        event.reload
        skip("Add assertions for updated state #time")
        expect(event.title).to eq(new_attributes[:title])
        expect(event.description).to eq(new_attributes[:description])
      end

      it 'assigns the requested event as @event' do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: valid_attributes}, session: valid_session
        expect(assigns(:event)).to eq(event)
      end

      it 'redirects to the event' do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: valid_attributes}, session: valid_session
        expect(response).to redirect_to(event)
      end
    end

    context 'with invalid params' do
      it 'assigns the event as @event' do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: invalid_attributes}, session: valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, params: {id: event.to_param}, session: valid_session
      }.to change(Event, :count).by(-1)
    end

    it 'redirects to the posts list' do
      event = Event.create! valid_attributes
      delete :destroy, params: {id: event.to_param}, session: valid_session
      expect(response).to redirect_to(events_url)
    end
  end

end
