import { types } from './actions'

const initialState = {
  isFetching: false,
  isAuthenticated: true,
  user: {
    profile: {
      display_name: 'John',
    },
  },
}

export default function auth (state = initialState, action) {
  switch (action.type) {
    case types.AUTH_REQUEST:
      return {
        ...state,
        isFetching: true,
      }
    case types.AUTH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        user: action.user,
        isAuthenticated: !!action.user.accessToken,
      }
    default:
      return state
  }
}
