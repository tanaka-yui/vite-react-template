import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import localizedFormat from 'dayjs/plugin/localizedFormat'
import timezone from 'dayjs/plugin/timezone'
import utc from 'dayjs/plugin/utc'

import 'dayjs/locale/ja'

dayjs.locale('ja')
dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.extend(localizedFormat)
dayjs.extend(customParseFormat)
dayjs.tz.setDefault('Asia/Tokyo')

export type Day = dayjs.Dayjs

export enum DateFormat {
  RFC3339 = 'YYYY-MM-DDTHH:mm:ssZ',
  DATE = 'YYYY-MM-DD',
  DATE_TIME_HOUR = 'YYYY-MM-DD HH',
  DATE_TIME_MINUTE = 'YYYY-MM-DD HH:mm',
  DATE_TIME_MINUTE_SLASH = 'YYYY/MM/DD HH:mm',
  DATE_TIME = 'YYYY-MM-DD HH:mm:ss',
  DATE_SLASH = 'YYYY/MM/DD',
  DATE_JA = 'YYYY年MM月DD日',
  DATE_JA_SLASH = 'YYYY/MM/DD(ddd)',
  DATE_TIME_JA = 'YYYY年MM月DD日(ddd) HH:mm',
  DATE_TIME_JA_SLASH = 'YYYY/MM/DD/(ddd) HH:mm',
  TIME = 'HH:mm:ss.SSSZ',
  MINUTES = 'mm:ss.SSSZ',
  HOUR_MINUTE = 'HH:mm',
  YEAR = 'YYYY',
  YEAR_JA = 'YYYY年',
  MONTH = 'MM',
  MONTH_JA = 'MM月',
  DAY_JA = 'DD日',
  MONTH_DAY_TIME_JA = 'M月D日（ddd） HH:mm',
  YEAR_MONTH = 'YYYY-MM',
  YEAR_MONTH_JA = 'YYYY年M月',
  BIGQUERY_TIMESTAMP = 'YYYY-MM-DD HH:mm:ss.SSSZ',
}

/**
 * datetimeFormat
 * datetimeが空の場合は現在時刻で返す
 * @param datetime
 * @param format
 * @returns {string}
 */
export const formatDatetime = (datetime: any, format: DateFormat): string => {
  if (!datetime) {
    return dayjs().format(format)
  }

  return dayjs(datetime).format(format)
}

/**
 * formatLocaleDatetime
 * datetimeが空の場合は現在時刻で返す
 * @param datetime
 * @param format
 * @param tz timezone string ex. 'Asia/Tokyo'
 * @returns {string}
 */
export const formatLocaleDatetime = (datetime: any, format: DateFormat, tz?: string): string => {
  if (!datetime) {
    return dayjs().tz('Asia/Tokyo').format(format)
  }

  return dayjs(datetime)
    .tz(tz || 'Asia/Tokyo')
    .format(format)
}

export const toDate = (str: string): Date => {
  return dayjs(str).toDate()
}

export const toDateWithFormat = (str: string, format: string): Date => {
  return dayjs(str, format).toDate()
}

export const sanitizeTime = (str: string | Date): Date => {
  return toDate(`${formatDatetime(str, DateFormat.DATE_TIME_MINUTE)}:00`)
}

/**
 * isNew
 * @param publishedTime
 * @param comparisonTime
 * @returns {boolean}
 */
export const isNew = (publishedTime: string, comparisonTime: string = dayjs().format()): boolean => {
  const comparisonDatetime = new Date(comparisonTime)
  const time = new Date(publishedTime)
  comparisonDatetime.setDate(comparisonDatetime.getDate() - 1)
  return comparisonDatetime.getTime() < time.getTime()
}

export const now = (tz = 'Asia/Tokyo') => {
  return dayjs().tz(tz)
}

export const dayOf = (value: string | number) => {
  return dayjs(value)
}

export const dayOfFirst = (value: string | number | dayjs.Dayjs) => {
  return dayjs(value).startOf('day')
}

export const dayOfLast = (value: string | number | dayjs.Dayjs) => {
  return dayjs(value).endOf('day')
}

export const isInclude = (orgStartDate: Date, orgEndDate: Date, newStartDate: Date, newEndDate: Date): boolean => {
  return dayjs(newStartDate).isAfter(orgStartDate) && dayjs(newEndDate).isBefore(orgEndDate)
}

export const isSame = (orgStartDate: Date, orgEndDate: Date, newStartDate: Date, newEndDate: Date): boolean => {
  return dayjs(newStartDate).isSame(orgStartDate) && dayjs(newEndDate).isSame(orgEndDate)
}

export const isIncludeStartDate = (orgStartDate: Date, orgEndDate: Date, newStartDate: Date, newEndDate: Date): boolean => {
  const orgStartMoment = dayjs(orgStartDate)
  const orgEndMoment = dayjs(orgEndDate)
  const newStartMoment = dayjs(newStartDate)
  const newEndMoment = dayjs(newEndDate)

  return newStartMoment.isAfter(orgStartMoment) && newStartMoment.isBefore(orgEndMoment) && newEndMoment.isAfter(orgEndMoment)
}

export const isIncludeEndDate = (orgStartDate: Date, orgEndDate: Date, newStartDate: Date, newEndDate: Date): boolean => {
  const orgStartMoment = dayjs(orgStartDate)
  const orgEndMoment = dayjs(orgEndDate)
  const newStartMoment = dayjs(newStartDate)
  const newEndMoment = dayjs(newEndDate)

  return newEndMoment.isAfter(orgStartMoment) && newEndMoment.isBefore(orgEndMoment) && newStartMoment.isBefore(orgStartMoment)
}

export const combine = (orgStartDate: Date, orgEndDate: Date, newStartDate: Date, newEndDate: Date) => {
  let mergedStartDate = orgStartDate
  let mergedEndDate = orgEndDate

  if (isIncludeStartDate(orgStartDate, orgEndDate, newStartDate, newEndDate)) {
    mergedEndDate = newEndDate
  }
  if (isIncludeEndDate(orgStartDate, orgEndDate, newStartDate, newEndDate)) {
    mergedStartDate = newStartDate
  }

  return { mergedStartDate, mergedEndDate }
}
