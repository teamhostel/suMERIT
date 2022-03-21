import React, {Component} from 'react'

class PageHeader extends Component {
  render() {
    return (

    <div className="PageHeader">
      <div className="flex flex-col items-center justify-center mt-32">

          <nav className="flex justify-around py-4 bg-white/80
              backdrop-blur-md shadow-md w-full
              fixed top-0 left-0 right-0 z-10">


              <div className="flex items-center">

              <img className="h-10 object-cover" src="/badge_base_purp_glo_on_trans.png" alt="Logo" />
                  <h3 className="text-2xl font-medium text-blue-500">
                      suMERIT
                  </h3>
              </div>


              <div className="items-center hidden space-x-8 lg:flex">
                  <a className="flex text-gray-600 hover:text-blue-500
                      cursor-pointer transition-colors duration-300">
                      Badge Factory
                  </a>

                  <a className="flex text-gray-600
                      cursor-pointer transition-colors duration-300
                      font-semibold text-blue-600">
                      Mint Badge
                  </a>

                  <a className="flex text-gray-600 hover:text-blue-500
                      cursor-pointer transition-colors duration-300">
                      Submit Contribution
                  </a>
              </div>


              <div className="flex items-center space-x-5">


              </div>
          </nav>

      </div>
      </div>

    );
  }
}

export default PageHeader
