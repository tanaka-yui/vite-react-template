import { UAParser } from 'ua-parser-js'

type OS = {
  name?: string
  version?: string
}

type Browser = {
  name?: string
  version?: string
  major?: string
}

export class UserAgentUtils {
  private readonly userAgent: string
  private readonly parser: any

  constructor(userAgent = '') {
    this.userAgent = userAgent.toLowerCase()
    this.parser = new UAParser(userAgent)
  }

  public getOS(): OS {
    return (
      this.parser.getOS() || {
        name: '',
        version: '',
      }
    )
  }

  public getBrowser(): Browser {
    return (
      this.parser.getBrowser() || {
        name: '',
        version: '',
        major: '',
      }
    )
  }

  public isSmartPhone(): boolean {
    const allowOSList = ['ios', 'android']
    return allowOSList.includes(this.parser.getOS().name?.toLowerCase())
  }

  public isIOS(): boolean {
    const allowOSList = ['ios']
    return allowOSList.includes(this.parser.getOS().name?.toLowerCase())
  }

  private isIPadOver13(): boolean {
    if (typeof window !== 'undefined' && typeof document !== 'undefined') {
      return this.userAgent.includes('macintosh') && 'ontouchend' in document
    }
    return false
  }

  public isIPad(): boolean {
    const ipad = /ipad/i.test(this.userAgent)
    if (typeof window !== 'undefined' && typeof document !== 'undefined') {
      return (this.isIOS() && (ipad || this.isIPadOver13())) || (!this.isIOS() && this.isIPadOver13())
    }
    return ipad
  }

  public isEdge(): boolean {
    return this.userAgent.includes('chrome') && this.userAgent.includes('edg') && !this.userAgent.includes('opr')
  }

  public isChrome(): boolean {
    return this.userAgent.includes('chrome') && !this.userAgent.includes('edg') && !this.userAgent.includes('opr')
  }

  public isSafari(): boolean {
    return this.userAgent.includes('safari') && !this.userAgent.includes('chrome')
  }

  public getIPadVersion(): number {
    try {
      if (typeof window !== 'undefined' && typeof document !== 'undefined') {
        if (this.isIPadOver13()) {
          // over iPadOS 13
          const m = this.userAgent.match(/version\/([0-9].+?) safari/)
          if (!m || !m.length) return 0
          return parseFloat(m[1])
        } else {
          // under iPadOS 13
          const m = this.userAgent.match(/ipad; cpu os (.+?) like/)
          if (!m || !m.length) return 0
          return parseFloat(m[1].replace('_', '.'))
        }
      }
    } catch (e) {
      console.log(e) // eslint-disable-line no-console
    }
    return 0
  }

  public getIPhoneVersion(): number {
    try {
      if (typeof window !== 'undefined' && typeof document !== 'undefined') {
        const m = this.userAgent.match(/iphone; cpu iphone os (.+?) like/)
        if (!m || !m.length) return 0
        return parseFloat(m[1].replace('_', '.'))
      }
    } catch (e) {
      console.log(e) // eslint-disable-line no-console
    }
    return 0
  }
}
